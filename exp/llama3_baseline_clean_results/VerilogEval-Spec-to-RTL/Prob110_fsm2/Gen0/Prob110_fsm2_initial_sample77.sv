module TopModule(
    input clk,
    input areset,
    input j,
    input k,
    output reg out
);

reg [1:0] current_state, next_state;

localparam OFF = 2'b00;
localparam ON  = 2'b01;

always @(*) begin
    case (current_state)
        OFF: begin
            if (j) next_state = ON;
            else next_state = OFF;
        end
        ON: begin
            if (k) next_state = OFF;
            else next_state = ON;
        end
        default: next_state = OFF;
    endcase
end

always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= OFF;
        out <= 0;
    end
    else begin
        current_state <= next_state;
        case (current_state)
            OFF: out <= 0;
            ON:  out <= 1;
            default: out <= 0;
        endcase
    end
end

endmodule