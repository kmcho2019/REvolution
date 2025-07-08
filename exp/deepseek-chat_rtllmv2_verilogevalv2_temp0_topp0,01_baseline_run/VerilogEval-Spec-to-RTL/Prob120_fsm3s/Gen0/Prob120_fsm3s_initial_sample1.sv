module TopModule (
    input clk,
    input reset,
    input in,
    output out
);

    // State encoding
    localparam [1:0] A = 2'b00;
    localparam [1:0] B = 2'b01;
    localparam [1:0] C = 2'b10;
    localparam [1:0] D = 2'b11;

    reg [1:0] current_state, next_state;

    // State transition logic (sequential)
    always @(posedge clk) begin
        if (reset)
            current_state <= A;
        else
            current_state <= next_state;
    end

    // Next state logic (combinational)
    always @(*) begin
        case (current_state)
            A: next_state = in ? B : A;
            B: next_state = in ? B : C;
            C: next_state = in ? D : A;
            D: next_state = in ? B : C;
            default: next_state = A;
        endcase
    end

    // Output logic (combinational, Moore style)
    assign out = (current_state == D);

endmodule