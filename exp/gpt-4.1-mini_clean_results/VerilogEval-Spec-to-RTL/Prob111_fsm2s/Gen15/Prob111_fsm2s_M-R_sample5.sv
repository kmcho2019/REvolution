module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

    // One-hot state encoding
    localparam OFF = 2'b01;
    localparam ON  = 2'b10;

    reg [1:0] state, next_state;

    // Next state combinational logic using assign style
    wire off_state = state[0];
    wire on_state  = state[1];

    assign next_state = reset ? OFF :
                        (off_state ? (j ? ON : OFF) :
                         on_state  ? (k ? OFF : ON) :
                         OFF); // default to OFF if unknown state

    // State register with synchronous reset
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output derived directly from state (Moore output)
    assign out = state[1]; // ON state bit

endmodule