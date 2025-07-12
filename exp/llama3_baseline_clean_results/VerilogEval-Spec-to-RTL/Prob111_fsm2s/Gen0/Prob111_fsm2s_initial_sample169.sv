module TopModule(
    input clk,
    input reset,
    input j,
    input k,
    output out
);

// Define the states
reg [0:0] state; // Using 1-bit for simplicity
parameter OFF = 1'b0;
parameter ON = 1'b1;

// Define the next state and output
reg [0:0] next_state;
reg out_reg;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
            out_reg = 0;
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
            out_reg = 1;
        end
    endcase
end

assign out = out_reg;

endmodule