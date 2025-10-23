// Define the state enum
enum logic [0:0] {OFF, ON} state, next_state;

module TopModule(
    input  logic clk,
    input  logic reset,
    input  logic j,
    input  logic k,
    output logic out
);

always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
    endcase
end

// Output is directly dependent on the current state
assign out = (state == ON)? 1'b1 : 1'b0;

endmodule