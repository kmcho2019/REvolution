module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define the states
localparam [0:0] OFF = 1'b0;
localparam [0:0] ON = 1'b1;

// Define the current state
reg [0:0] current_state;

// Asynchronous reset
always @(posedge areset or negedge clk) begin
    if (areset) begin
        current_state <= OFF;
    end else if (~areset) begin
        case (current_state)
            OFF: begin
                if (j) begin
                    current_state <= ON;
                end else begin
                    current_state <= OFF;
                end
            end
            ON: begin
                if (k) begin
                    current_state <= OFF;
                end else begin
                    current_state <= ON;
                end
            end
        endcase
    end
end

// Output logic
always @(posedge clk) begin
    case (current_state)
        OFF: out <= 1'b0;
        ON: out <= 1'b1;
    endcase
end

endmodule