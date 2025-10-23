module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

    // Define the states
    parameter B = 1'b0;
    parameter A = 1'b1;

    reg [0:0] current_state;
    reg [0:0] next_state;

    // State register
    always_ff @(posedge clk) begin
        if (reset) begin
            current_state <= B;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic
    always_comb begin
        case (current_state)
            B: begin
                if (in == 1'b0) begin
                    next_state = A;
                end else begin
                    next_state = B;
                end
            end
            A: begin
                if (in == 1'b0) begin
                    next_state = B;
                end else begin
                    next_state = A;
                end
            end
            default: next_state = B;
        endcase
    end

    // Output logic
    always_comb begin
        case (current_state)
            B: out = 1'b1;
            A: out = 1'b0;
            default: out = 1'b0;
        endcase
    end

endmodule