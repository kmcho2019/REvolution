module TopModule (
    input  clk,
    input  areset,
    input  x,
    output z
);

// Define the one-hot encoding for states A and B
reg [1:0] state;
localparam A = 2'b10;
localparam B = 2'b01;

// Combinational logic for next state
always @(*) begin
    case (state)
        A: begin
            if (x == 1'b0) begin
                state <= A;
            end else begin
                state <= B;
            end
        end
        B: begin
            state <= B;
        end
        default: begin
            state <= A;
        end
    endcase
end

// Sequential logic for state update
always @(posedge clk or posedge areset) begin
    if (areset) begin
        state <= A;
    end else begin
        // No change in state
    end
end

// Combinational logic for output z
always @(*) begin
    case (state)
        A: begin
            if (x == 1'b0) begin
                z <= 1'b0;
            end else begin
                z <= 1'b1;
            end
        end
        B: begin
            if (x == 1'b0) begin
                z <= 1'b1;
            end else begin
                z <= 1'b0;
            end
        end
        default: begin
            z <= 1'b0;
        end
    endcase
end

endmodule