module TopModule(
    input clk,
    input reset,
    input s,
    input w,
    output reg z
);

// Define the states
parameter A = 2'b00;
parameter B0 = 2'b01;
parameter B1 = 2'b10;
parameter B2 = 2'b11;

// Current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Counter for w
reg [1:0] w_count;

// Initialize the current state
initial current_state = A;

always @ (posedge clk) begin
    if (reset) begin
        current_state <= A;
        w_count <= 0;
    end else begin
        current_state <= next_state;
        case (current_state)
            A: begin
                if (s) begin
                    next_state <= B0;
                    w_count <= 0;
                end else begin
                    next_state <= A;
                end
            end
            B0: begin
                if (w) begin
                    w_count <= w_count + 1;
                end
                next_state <= B1;
            end
            B1: begin
                if (w) begin
                    w_count <= w_count + 1;
                end
                next_state <= B2;
            end
            B2: begin
                if (w) begin
                    w_count <= w_count + 1;
                end
                if (w_count == 2) begin
                    z <= 1;
                end else begin
                    z <= 0;
                end
                next_state <= B0;
                w_count <= 0;
            end
        endcase
    end
end

endmodule