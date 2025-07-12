module TopModule (
    input a,
    input b,
    input sel_b1,
    input sel_b2,
    output out_assign,
    output out_always
    // output reg error_flag  // Optional error detection
);

    // One-hot encoded selection states
    localparam SEL_A = 2'b01;
    localparam SEL_B = 2'b10;
    
    // Selection decoder
    wire [1:0] select_state;
    assign select_state = ({sel_b1, sel_b2} == 2'b11) ? SEL_B : SEL_A;
    
    // Optional error detection (commented out as not required)
    // always @(*) begin
    //     error_flag = (select_state != SEL_A) && (select_state != SEL_B);
    // end

    // Assign-based implementation using priority encoding
    assign out_assign = (select_state == SEL_B) ? b : a;

    // Always-based implementation
    reg out_always_reg;
    always @(*) begin
        case (select_state)
            SEL_A: out_always_reg = a;
            SEL_B: out_always_reg = b;
            default: out_always_reg = a;  // Safe default
        endcase
    end
    assign out_always = out_always_reg;
endmodule