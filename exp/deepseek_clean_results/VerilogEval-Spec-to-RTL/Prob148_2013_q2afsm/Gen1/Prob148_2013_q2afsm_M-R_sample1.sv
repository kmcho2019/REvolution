module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

// State encoding
typedef enum logic [1:0] {
    STATE_A = 2'b00,
    STATE_B = 2'b01,
    STATE_C = 2'b10,
    STATE_D = 2'b11
} state_t;

state_t current_state;

// Combined state transition and storage
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= STATE_A;
        g <= 3'b000;
    end
    else begin
        case (current_state)
            STATE_A: begin
                if (r[0]) begin
                    current_state <= STATE_B;
                    g <= 3'b001;  // g[0]=1
                end
                else if (r[1]) begin
                    current_state <= STATE_C;
                    g <= 3'b010;  // g[1]=1
                end
                else if (r[2] && !(|r[1:0])) begin
                    current_state <= STATE_D;
                    g <= 3'b100;  // g[2]=1
                end
                else begin
                    current_state <= STATE_A;
                    g <= 3'b000;
                end
            end
            STATE_B: begin
                if (r[0]) begin
                    current_state <= STATE_B;
                    g <= 3'b001;
                end
                else begin
                    current_state <= STATE_A;
                    g <= 3'b000;
                end
            end
            STATE_C: begin
                if (r[1]) begin
                    current_state <= STATE_C;
                    g <= 3'b010;
                end
                else begin
                    current_state <= STATE_A;
                    g <= 3'b000;
                end
            end
            STATE_D: begin
                current_state <= STATE_A;
                g <= 3'b000;
            end
            default: begin
                current_state <= STATE_A;
                g <= 3'b000;
            end
        endcase
    end
end

endmodule