module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

// Define states
localparam OFF = 0;
localparam ON = 1;

// State register
reg current_state;

// Next state logic
always @(*) begin
    case(current_state)
        OFF: begin
            if (j) begin
                out = 0;
                next_state = ON;
            end else begin
                out = 0;
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                out = 1;
                next_state = OFF;
            end else begin
                out = 1;
                next_state = ON;
            end
        end
        default: begin
            out = 0;
            next_state = OFF;
        end
    endcase
end

reg next_state;

// State update logic
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
        out <= 0;
    end else begin
        current_state <= next_state;
    end
end

assign out = (current_state == ON) ? 1 : 0;

endmodule