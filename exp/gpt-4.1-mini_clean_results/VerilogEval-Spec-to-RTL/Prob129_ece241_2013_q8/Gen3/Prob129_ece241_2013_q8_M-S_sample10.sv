module TopModule(
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // State encoding
    parameter S0 = 2'b00; // no match
    parameter S1 = 2'b01; // matched '1'
    parameter S2 = 2'b10; // matched '10'

    reg [1:0] state, next_state;

    // Next state and output logic
    always @(*) begin
        z = 1'b0;
        if (state == S0) begin
            if (x)
                next_state = S1;
            else
                next_state = S0;
        end else if (state == S1) begin
            if (x)
                next_state = S1;
            else
                next_state = S2;
        end else begin // state == S2
            if (x) begin
                next_state = S1;
                z = 1'b1; // sequence "101" detected
            end else
                next_state = S0;
        end
    end

    // State register with async negative edge reset
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn)
            state <= S0;
        else
            state <= next_state;
    end

endmodule