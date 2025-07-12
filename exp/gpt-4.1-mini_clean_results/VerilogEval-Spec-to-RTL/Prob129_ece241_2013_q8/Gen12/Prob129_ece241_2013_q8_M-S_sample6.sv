module TopModule (
    input  clk,
    input  aresetn,
    input  x,
    output reg z
);

    reg [1:0] state, next_state;

    // State encoding
    localparam S0 = 2'd0; // no match
    localparam S1 = 2'd1; // matched '1'
    localparam S2 = 2'd2; // matched "10"

    // State register with asynchronous negative-edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

    // Next state and output logic
    always @(*) begin
        z = 1'b0;
        if (state == S0) begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end else if (state == S1) begin
            if (~x)
                next_state = S2;
            else
                next_state = S1;
        end else if (state == S2) begin
            if (x) begin
                next_state = S1;
                z = 1'b1; // sequence "101" detected
            end else
                next_state = S0;
        end else begin
            next_state = S0;
        end
    end

endmodule