module TopModule (
    input        clk,
    input        L,
    input        q_in,     // this flip-flop's previous q
    input  [1:0] q_pair,   // two other q bits used for XOR feedback calculation
    input        r_in,     // load value for this bit
    output reg   Q
);

    wire feedback;  // XOR feedback for shift mode
    wire d;         // next state data input to flip-flop

    // Compute feedback: bit 0 and bit 2 use XOR of q[1] and q[2] or q[0] and q[1] depending on instance.
    // For the original full_module:
    // q[2] <= r[2] or q[2] shifted from q[2] (no XOR)
    // q[1] <= r[1] or q[0] shifted from q[1]
    // q[0] <= r[0] or (q[1] ^ q[2]) shifted from q[0]
    //
    // But since this is a reusable module, feedback is XOR of q_pair[0] and q_pair[1].
    assign feedback = q_pair[0] ^ q_pair[1];

    // If L=1, load from r_in; else shift with feedback applied on the appropriate bit.
    // Use feedback on bits that require XOR, otherwise just q_in for pass-through shift.
    // We distinguish whether to use feedback or direct q_in based on q_pair.
    // Here we choose d = L ? r_in : feedback_or_q_in depending on instance.
    // So top-level full_module instantiations must set q_pair and q_in accordingly.

    // Use feedback when q_pair is used; otherwise just pass q_in through.
    // If q_pair inputs are connected properly:
    // For bit 0, feedback is q[1]^q[2]
    // For bit 1, feedback is just q[0] (q_pair will be {q[0],dummy} and feedback reduces accordingly)
    // For bit 2, no feedback XOR, just q[2] passed.

    // To keep uniformity, feedback line always XORs q_pair[0]^q_pair[1].
    // For bits without XOR, feed duplicated q_in or zero to q_pair to force feedback=0 or q_in.

    // So d = L ? r_in : feedback (if feedback needed) or q_in (if no feedback needed)
    // We choose feedback as the shifted in data when L=0.

    assign d = L ? r_in : feedback;

    always @(posedge clk) begin
        Q <= d;
    end

endmodule