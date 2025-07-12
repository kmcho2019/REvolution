module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Booth encoder signals
wire [1:0] booth_sel [1:0];
wire [4:0] booth_a = {mul_a[3], mul_a}; // sign-extended multiplicand
wire [4:0] booth_2a = {mul_a, 1'b0};    // 2*A (no overflow possible for 4-bit)

// Append 0 at LSB for Booth encoding
wire [4:0] b_ext = {mul_b, 1'b0};

// Generate Booth encoding groups
assign booth_sel[0] = {b_ext[1], b_ext[0]};
assign booth_sel[1] = {b_ext[3], b_ext[2]};

// Pipeline stage 1: Booth encoding and partial product generation
reg [5:0] pp0, pp1;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        pp0 <= 6'b0;
        pp1 <= 6'b0;
    end else begin
        // First partial product (LSB group)
        case (booth_sel[0])
            2'b01: pp0 <= {booth_a[4], booth_a};    // +A
            2'b10: pp0 <= {~booth_a[4], ~booth_a + 1}; // -A
            2'b11: pp0 <= {booth_2a[4], booth_2a};  // +2A
            default: pp0 <= 6'b0;                   // 0
        endcase
        
        // Second partial product (MSB group)
        case (booth_sel[1])
            2'b01: pp1 <= {booth_a[4], booth_a} << 2;    // +A<<2
            2'b10: pp1 <= ({~booth_a[4], ~booth_a + 1}) << 2; // -A<<2
            2'b11: pp1 <= {booth_2a[4], booth_2a} << 2;  // +2A<<2
            default: pp1 <= 6'b0;                        // 0
        endcase
    end
end

// Pipeline stage 2: Carry-save addition
reg [7:0] sum, carry;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 8'b0;
        carry <= 8'b0;
    end else begin
        // First level of addition (pp0 + pp1)
        {carry[6:0], sum[5:0]} <= pp0 + pp1;
        carry[7] <= 1'b0;
        sum[7:6] <= 2'b0;
    end
end

// Final stage: Carry propagation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= sum + {carry[6:0], 1'b0};
    end
end

endmodule