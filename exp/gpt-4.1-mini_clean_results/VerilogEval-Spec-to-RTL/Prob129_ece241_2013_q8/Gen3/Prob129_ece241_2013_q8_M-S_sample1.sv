module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] state, next_state;

    localparam S0 = 2'd0,
               S1 = 2'd1,
               S2 = 2'd2;

    // State register with asynchronous negative reset
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
            if (!x)
                next_state = S2;
            else
                next_state = S1;
        end else begin // state == S2
            if (x) begin
                next_state = S1;
                z = 1'b1;
            end else
                next_state = S0;
        end
    end

endmodule