module TopModule(
    input  clk,
    input  aresetn,
    input  x,
    output z
);

reg [1:0] state;

// Asynchronous reset and sequential logic
always @(posedge clk or negedge aresetn) begin
    if (!aresetn) begin
        state <= 2'b00;  // Idle
    end else begin
        case(state)
            2'b00: begin  // Idle
                if (x == 1'b1) state <= 2'b10;  // State1
                else state <= 2'b00;
            end
            2'b10: begin  // State1
                if (x == 1'b0) state <= 2'b01;  // State2
                else state <= 2'b10;
            end
            2'b01: begin  // State2
                if (x == 1'b1) state <= 2'b10;  // State1 and output high
                else state <= 2'b00;
            end
            default: state <= 2'b00;
        endcase
    end
end

// Output logic
assign z = (state == 2'b01) && (x == 1'b1);

endmodule