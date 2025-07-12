module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // State encoding with localparam for better practice
    localparam A = 2'b00;
    localparam B = 2'b01;
    localparam C = 2'b10;
    localparam D = 2'b11;

    reg [1:0] state;

    // State transition logic with single always block
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
            out <= 1'b0;
        end else begin
            case (state)
                A: state <= in ? B : A;
                B: state <= in ? B : C;
                C: state <= in ? D : A;
                D: state <= in ? B : C;
                default: state <= A; // Safe default
            endcase
            
            // Registered output for better timing
            out <= (state == D);
        end
    end

endmodule