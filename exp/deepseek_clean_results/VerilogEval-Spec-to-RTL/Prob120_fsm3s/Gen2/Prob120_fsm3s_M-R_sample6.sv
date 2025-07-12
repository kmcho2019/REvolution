module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // One-hot state encoding
    parameter A = 4'b0001;
    parameter B = 4'b0010;
    parameter C = 4'b0100;
    parameter D = 4'b1000;

    // State register (4 bits for one-hot)
    reg [3:0] current_state;

    // Next state logic using continuous assignments
    wire [3:0] next_state;
    assign next_state = reset ? A : 
                       (current_state == A) ? (in ? B : A) :
                       (current_state == B) ? (in ? B : C) :
                       (current_state == C) ? (in ? D : A) :
                       (current_state == D) ? (in ? B : C) : A;

    // Output assignment (Moore machine)
    assign out = (current_state == D);

    // State register update
    always @(posedge clk) begin
        current_state <= next_state;
    end

endmodule