module TopModule (
    input  clk,
    input  aresetn,  // active low async reset
    input  x,
    output reg z
);

    // One-hot state encoding
    reg s0, s1, s2;        // state flip-flops
    reg ns0, ns1, ns2;     // next state signals

    // Asynchronous negative-edge reset, synchronous state update
    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            s0 <= 1'b1;   // reset to initial state S0
            s1 <= 1'b0;
            s2 <= 1'b0;
        end else begin
            s0 <= ns0;
            s1 <= ns1;
            s2 <= ns2;
        end
    end

    // Next state and output logic (Mealy FSM)
    always @(*) begin
        // default values
        ns0 = 1'b0;
        ns1 = 1'b0;
        ns2 = 1'b0;
        z   = 1'b0;

        if (s0) begin
            if (x) begin
                ns1 = 1'b1;  // got '1', move to S1
            end else begin
                ns0 = 1'b1;  // still no match, stay in S0
            end
            z = 1'b0;
        end else if (s1) begin
            if (!x) begin
                ns2 = 1'b1;  // got '0' after '1', move to S2
            end else begin
                ns1 = 1'b1;  // consecutive '1's, stay in S1
            end
            z = 1'b0;
        end else if (s2) begin
            if (x) begin
                ns1 = 1'b1;  // detected '101', output z=1, next state S1 for overlap
                z = 1'b1;
            end else begin
                ns0 = 1'b1;  // didn't complete sequence, reset to S0
                z = 1'b0;
            end
        end else begin
            // safety: if no states active, reset to S0
            ns0 = 1'b1;
            z = 1'b0;
        end
    end

endmodule