module LFSR (
    input  wire       clk,
    input  wire       rst,
    output wire [3:0] out
);

    reg [3:0] state;
    reg       feedback;
    reg [3:0] next_state;

    // Assign output directly from state register
    assign out = state;

    // Combinational logic to calculate feedback and next state
    always @(*) begin
        feedback = ~(state[3] ^ state[2]);
        next_state = {state[2:0], feedback};
    end

    // Sequential logic to update state on clk edge or reset
    always @(posedge clk) begin
        if (rst) begin
            state <= 4'b0000;
        end else begin
            state <= next_state;
        end
    end

endmodule