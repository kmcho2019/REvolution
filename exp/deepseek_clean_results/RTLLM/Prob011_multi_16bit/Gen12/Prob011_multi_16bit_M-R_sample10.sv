module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output [31:0] yout,
    output done
);

// State encoding
localparam IDLE = 1'b0;
localparam RUN  = 1'b1;

reg state;
reg [3:0] bit_pos;  // Down counter for bit position
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] product;

// Barrel shifter for on-demand shifting
wire [31:0] shifted_b = breg << bit_pos;

// State machine and calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        bit_pos <= 4'b1111;  // Initialize to 15 (down counter)
        areg <= 16'b0;
        breg <= 16'b0;
        product <= 32'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= RUN;
                    areg <= ain;
                    breg <= bin;
                    product <= 32'b0;
                    bit_pos <= 4'b1111;  // Start from MSB
                end
            end
            
            RUN: begin
                if (areg[bit_pos]) begin
                    product <= product + shifted_b;
                end
                
                if (bit_pos == 4'b0) begin
                    state <= IDLE;
                end
                else begin
                    bit_pos <= bit_pos - 1;
                end
            end
        endcase
    end
end

// Output assignments
assign done = (state == IDLE) && (bit_pos == 4'b1111);
assign yout = (state == IDLE) ? product : 32'b0;

endmodule