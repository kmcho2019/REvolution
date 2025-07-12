module TopModule(
    input clk,
    input a,
    input b,
    output out_assign,
    output out_always_comb,
    output reg out_always_ff
);

    // Define a LUT for the XOR operation
    wire xor_out;
    assign xor_out = a ^ b;

    // Define a FSM to manage the outputs
    reg [1:0] state;
    initial state = 2'b00;

    always @(posedge clk) begin
        case (state)
            2'b00: begin
                out_always_ff <= 1'b0;
                state <= 2'b01;
            end
            2'b01: begin
                out_always_ff <= xor_out;
                state <= 2'b10;
            end
            2'b10: begin
                out_always_ff <= out_always_ff;
                state <= 2'b11;
            end
            2'b11: begin
                out_always_ff <= out_always_ff;
                state <= 2'b00;
            end
        endcase
    end

    // Assign the outputs
    assign out_assign = xor_out;
    assign out_always_comb = xor_out;

endmodule