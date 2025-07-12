module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

// Define the states and their one-hot encodings
reg [1:0] state;
reg [1:0] next_state;

// State A: 2'b01
// State B: 2'b10

// Next state logic
always @(*) begin
    case (state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                next_state = 2'b01; // Stay in State A
            end else begin
                next_state = 2'b10; // Go to State B
            end
        end
        2'b10: begin // State B
            next_state = 2'b10; // Stay in State B
        end
        default: begin
            next_state = 2'b01; // Reset to State A
        end
    endcase
end

// Output logic
always @(*) begin
    case (state)
        2'b01: begin // State A
            if (x == 1'b0) begin
                z = 1'b0;
            end else begin
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            if (x == 1'b0) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
        end
        default: begin
            z = 1'b0; // Reset output
        end
    endcase
end

// State register
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= 2'b01; // Reset to State A
    end else begin
        state <= next_state;
    end
end

endmodule