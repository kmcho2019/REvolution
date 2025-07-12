module pe #(
    parameter WIDTH = 32
) (
    input wire clk,
    input wire rst,
    input wire signed [WIDTH-1:0] a,
    input wire signed [WIDTH-1:0] b,
    output reg signed [WIDTH-1:0] c,
    output wire overflow
);

    // Pipeline registers
    reg signed [WIDTH-1:0] a_reg, b_reg;
    reg signed [2*WIDTH-1:0] product_reg;
    reg signed [WIDTH-1:0] c_acc;
    
    // Booth encoding signals
    wire [WIDTH/2:0] booth_sel;
    wire [WIDTH-1:0] booth_pp [0:WIDTH/2];
    
    // Carry-save signals
    wire [WIDTH:0] sum, carry;
    
    // Overflow detection
    assign overflow = (c_acc[WIDTH-1] ^ product_reg[2*WIDTH-1]) & 
                    (product_reg[2*WIDTH-1] == c[WIDTH-1]);

    // Stage 1: Booth encoding and partial product generation
    always @(posedge clk) begin
        if (rst) begin
            a_reg <= 0;
            b_reg <= 0;
        end else begin
            a_reg <= a;
            b_reg <= b;
        end
    end

    // Booth encoder (radix-4)
    genvar i;
    generate
        for (i=0; i<=WIDTH/2; i=i+1) begin : booth
            if (i==0) begin
                assign booth_sel[i] = {b_reg[1:0], 1'b0};
            end else begin
                assign booth_sel[i] = b_reg[2*i+1:2*i-1];
            end
            
            always @(*) begin
                case (booth_sel[i])
                    3'b000, 3'b111: booth_pp[i] = 0;
                    3'b001, 3'b010: booth_pp[i] = a_reg;
                    3'b011:        booth_pp[i] = a_reg << 1;
                    3'b100:        booth_pp[i] = -a_reg << 1;
                    3'b101, 3'b110: booth_pp[i] = -a_reg;
                endcase
            end
        end
    endgenerate

    // Stage 2: Carry-save addition of partial products
    always @(posedge clk) begin
        if (rst) begin
            {sum, carry} <= 0;
        end else begin
            // Wallace tree reduction would go here in full implementation
            // Simplified for illustration:
            product_reg <= booth_pp[0] + (booth_pp[1] << 2) + 
                         (booth_pp[2] << 4) + (booth_pp[3] << 6);
        end
    end

    // Stage 3: Final accumulation with carry propagation
    always @(posedge clk) begin
        if (rst) begin
            c <= 0;
            c_acc <= 0;
        end else begin
            c_acc <= c;
            c <= c_acc + product_reg[WIDTH-1:0];
        end
    end

endmodule