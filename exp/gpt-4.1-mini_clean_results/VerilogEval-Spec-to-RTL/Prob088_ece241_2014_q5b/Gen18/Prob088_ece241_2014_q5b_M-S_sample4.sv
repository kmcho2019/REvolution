module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output reg  z
);

reg [1:0] state;  // one-hot: state[0]=A, state[1]=B

// Next state and output logic
always @* begin
    case (state)
        2'b01: begin // State A
            z = x;
        end
        2'b10: begin // State B
            z = ~x;
        end
        default: begin
            z = 0;
        end
    endcase
end

// State register with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // Reset to state A
    else begin
        case (state)
            2'b01: state <= x ? 2'b10 : 2'b01; // A -> B if x=1 else A
            2'b10: state <= 2'b10;              // B stays B
            default: state <= 2'b01;
        endcase
    end
end

endmodule