module TopModule(
    input clk,
    input areset,
    input x,
    output reg z
);

// One-hot encoding for states A and B
reg [1:0] state, next_state;

// Assigning one-hot encoding values
localparam A = 2'b01;
localparam B = 2'b10;

// Reset logic (asynchronous active-high)
always @(posedge areset or posedge clk) begin
    if(areset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// Next state and output logic
always @(*) begin
    case(state)
        A: begin
            if(x) begin
                next_state = B;
                z = 1'b1;
            end else begin
                next_state = A;
                z = 1'b0;
            end
        end
        B: begin
            if(x) begin
                next_state = B;
                z = 1'b0;
            end else begin
                next_state = B;
                z = 1'b1;
            end
        end
        default: begin
            next_state = A;
            z = 1'b0;
        end
    endcase
end

endmodule