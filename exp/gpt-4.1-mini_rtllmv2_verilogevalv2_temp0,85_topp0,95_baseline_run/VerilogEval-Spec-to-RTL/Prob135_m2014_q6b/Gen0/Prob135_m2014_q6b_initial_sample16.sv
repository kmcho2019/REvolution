module TopModule (
    input  [2:0] y,
    input        w,
    output       Y1
);

    wire y1_next;

    // Current state bits
    wire y2 = y[2];
    wire y1 = y[1];
    wire y0 = y[0];

    // Implement next state logic for y[1] only
    // Define y1_next based on current state y and input w per FSM transitions:

    // State A (000):
    // w=0 -> B(001): y1_next=0
    // w=1 -> A(000): y1_next=0
    // State B (001):
    // w=0 -> C(010): y1_next=1
    // w=1 -> D(011): y1_next=1
    // State C (010):
    // w=0 -> E(100): y1_next=0
    // w=1 -> D(011): y1_next=1
    // State D (011):
    // w=0 -> F(101): y1_next=0
    // w=1 -> A(000): y1_next=0
    // State E (100):
    // w=0 -> E(100): y1_next=0
    // w=1 -> D(011): y1_next=1
    // State F (101):
    // w=0 -> C(010): y1_next=1
    // w=1 -> D(011): y1_next=1

    // Combine these using a combinational logic expression or case statement

    // Using a case statement on y and w to assign y1_next

    // For simplicity, use a function or combinational always block

    // But since y and w are inputs, use combinational always_comb or assign with a case

    // Use assign + case expression for y1_next:

    // First combine y and w into a single value for case:

    wire [3:0] state_w = {y, w};

    reg y1_next_reg;
    always @(*) begin
        case(state_w)
            4'b0000: y1_next_reg = 1'b0; // A, w=0 -> B(001) y1=0
            4'b0001: y1_next_reg = 1'b0; // A, w=1 -> A(000) y1=0
            4'b0010: y1_next_reg = 1'b1; // B, w=0 -> C(010) y1=1
            4'b0011: y1_next_reg = 1'b1; // B, w=1 -> D(011) y1=1
            4'b0100: y1_next_reg = 1'b0; // C, w=0 -> E(100) y1=0
            4'b0101: y1_next_reg = 1'b1; // C, w=1 -> D(011) y1=1
            4'b0110: y1_next_reg = 1'b0; // D, w=0 -> F(101) y1=0
            4'b0111: y1_next_reg = 1'b0; // D, w=1 -> A(000) y1=0
            4'b1000: y1_next_reg = 1'b0; // E, w=0 -> E(100) y1=0
            4'b1001: y1_next_reg = 1'b1; // E, w=1 -> D(011) y1=1
            4'b1010: y1_next_reg = 1'b1; // F, w=0 -> C(010) y1=1
            4'b1011: y1_next_reg = 1'b1; // F, w=1 -> D(011) y1=1
            default: y1_next_reg = 1'b0; // default safe value
        endcase
    end

    assign y1_next = y1_next_reg;

    // Output Y1 is the current y[1]
    assign Y1 = y1;

endmodule