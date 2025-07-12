module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

    // State encoding
    localparam OFF = 1'b0;
    localparam ON  = 1'b1;

    reg state;
    wire next_state;

    // Next state combinational logic using assign
    assign next_state = (state == OFF) ? (j ? ON : OFF)
                      : (k ? OFF : ON);

    // State register with asynchronous reset and output logic combined
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= OFF;
            out <= 1'b0;
        end else begin
            state <= next_state;
            out <= next_state; // Moore output equals current state (OFF=0, ON=1)
        end
    end

endmodule