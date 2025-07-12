module TopModule (
    input clk,
    input areset,
    input in,
    output reg out
);

    // One-hot state encoding
    localparam [3:0] A = 4'b0001;
    localparam [3:0] B = 4'b0010;
    localparam [3:0] C = 4'b0100;
    localparam [3:0] D = 4'b1000;

    reg [3:0] state, next_state;

    // State transition logic
    always @(*) begin
        case (1'b1) // synthesis parallel_case
            state[A]: next_state = in ? B : A;
            state[B]: next_state = in ? B : C;
            state[C]: next_state = in ? D : A;
            state[D]: next_state = in ? B : C;
            default:  next_state = A;
        endcase
    end

    // State register with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= A;
        end else begin
            state <= next_state;
        end
    end

    // Registered output
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            out <= 1'b0;
        end else begin
            out <= state[D];
        end
    end

endmodule