module TopModule (
    input  clk,
    input  reset,
    input  in,
    output reg out
);

    // State encoding using localparam for clarity and synthesis friendliness
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state, next_state;

    // Combinational next state and output logic with explicit case and no redundant defaults
    always @(*) begin
        case (state)
            A: begin
                next_state = in ? B : A;
                out = 1'b0;
            end
            B: begin
                next_state = in ? B : C;
                out = 1'b0;
            end
            C: begin
                next_state = in ? D : A;
                out = 1'b0;
            end
            D: begin
                next_state = in ? B : C;
                out = 1'b1;
            end
            default: begin
                next_state = A;  // Safe fallback for undefined states
                out = 1'b0;
            end
        endcase
    end

    // Sequential logic: state register with synchronous active-high reset
    always @(posedge clk) begin
        if (reset)
            state <= A;
        else
            state <= next_state;
    end

endmodule