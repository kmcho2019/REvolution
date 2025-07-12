module edge_detect (
    input clk,
    input rst_n,
    input a,
    output reg rise,
    output reg down
);

reg a_prev;
reg state;

localparam IDLE = 1'b0;
localparam EDGE_DETECTED = 1'b1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        a_prev <= 1'b0;
        state <= IDLE;
        rise <= 1'b0;
        down <= 1'b0;
    end
    else begin
        a_prev <= a;
        
        case (state)
            IDLE: begin
                if (a && !a_prev) begin       // Rising edge
                    rise <= 1'b1;
                    state <= EDGE_DETECTED;
                end
                else if (!a && a_prev) begin  // Falling edge
                    down <= 1'b1;
                    state <= EDGE_DETECTED;
                end
            end
            
            EDGE_DETECTED: begin
                rise <= 1'b0;
                down <= 1'b0;
                state <= IDLE;
            end
        endcase
    end
end

endmodule