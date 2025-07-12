module TopModule (
    input  clk,
    input  areset,
    input  in,
    output out
);

    reg [0:0] state;
    reg [0:0] next_state;

    // Define the states
    localparam B = 1'b1;
    localparam A = 1'b0;

    // Next state logic
    always @(*) begin
        case (state)
            B: begin
                if (in == 1'b1) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            A: begin
                if (in == 1'b1) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            default: begin
                next_state = B;
            end
        endcase
    end

    // State register with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= B;
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign out = state;

endmodule