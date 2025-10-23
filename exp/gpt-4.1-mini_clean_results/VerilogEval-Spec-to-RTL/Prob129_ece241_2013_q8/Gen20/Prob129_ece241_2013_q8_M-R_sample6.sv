module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

    localparam [1:0]
        S_IDLE = 2'd0,
        S_1    = 2'd1,
        S_10   = 2'd2;

    reg [1:0] state;

    // Next-state logic using a combinational function with case statement
    wire [1:0] next_state = (state == S_IDLE) ? (x ? S_1 : S_IDLE) :
                            (state == S_1)    ? (x ? S_1 : S_10) :
                                               (x ? S_1 : S_IDLE);

    // Mealy output combinational logic
    assign z = (state == S_10) & x;

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S_IDLE;
        else
            state <= next_state;
    end

endmodule