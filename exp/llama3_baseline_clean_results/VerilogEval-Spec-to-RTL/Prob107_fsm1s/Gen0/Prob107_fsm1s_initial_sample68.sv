module TopModule(
    input clk,
    input reset,
    input in,
    output out
);

    // Define states
    reg [0:0] state; // Using 1 bit to represent 2 states (0 for A, 1 for B)
    parameter A = 1'b0;
    parameter B = 1'b1;

    // Next state logic
    always @(posedge clk) begin
        if(reset) begin
            state <= B;
        end else begin
            case(state)
                A: begin
                    if(in == 1'b0) begin
                        state <= B;
                    end else begin
                        state <= A;
                    end
                end
                B: begin
                    if(in == 1'b0) begin
                        state <= A;
                    end else begin
                        state <= B;
                    end
                end
            endcase
        end
    end

    // Output logic
    always @(state) begin
        case(state)
            A: out <= 1'b0;
            B: out <= 1'b1;
        endcase
    end

endmodule