module TopModule(
    input clk,
    input reset,
    input in,
    output reg out
);

reg [0:0] state; // 1-bit state variable

// Define the states
localparam B = 1'b1;
localparam A = 1'b0;

always @ (posedge clk) begin
    if (reset) begin // synchronous reset
        state <= B;
    end else begin
        case (state)
            B: begin
                if (in == 1'b0) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            A: begin
                if (in == 1'b0) begin
                    state <= B;
                end else begin
                    state <= A;
                end
            end
            default: state <= B; // default to state B
        endcase
    end
end

// Output logic
always @ (*) begin
    case (state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1; // default to out = 1
    endcase
end

endmodule