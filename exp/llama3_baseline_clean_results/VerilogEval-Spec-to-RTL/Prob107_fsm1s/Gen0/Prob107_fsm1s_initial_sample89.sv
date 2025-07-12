module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

reg [0:0] state;  // Using [0:0] to declare a single bit reg
reg [0:0] next_state;

// State definitions
localparam B = 1'b0;
localparam A = 1'b1;

always @ (posedge clk or posedge reset) begin
    if(reset) begin
        state <= B;
    end else begin
        case(state)
            B: begin
                if(in == 0) begin
                    next_state <= A;
                end else begin
                    next_state <= B;
                end
            end
            A: begin
                if(in == 0) begin
                    next_state <= B;
                end else begin
                    next_state <= A;
                end
            end
            default: next_state <= B;  // Default to B for invalid states
        endcase
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        B: out <= 1'b1;
        A: out <= 1'b0;
        default: out <= 1'b0;  // Default output for invalid states
    endcase
end

endmodule