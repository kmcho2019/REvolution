module TopModule(
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

reg [2:0] state; // FSM state: STATE_A (0), STATE_B (1), STATE_C (2), STATE_D (3), STATE_E (4), STATE_F (5)
reg [1:0] seq_counter; // Counter to track sequence '1, 0, 1'
reg [1:0] y_timer; // Timer to count cycles after sequence detection

localparam STATE_A = 3'b000;
localparam STATE_B = 3'b001;
localparam STATE_C = 3'b010;
localparam STATE_D = 3'b011;
localparam STATE_E = 3'b100;
localparam STATE_F = 3'b101;

always @ (posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        f <= 0;
        g <= 0;
        seq_counter <= 0;
        y_timer <= 0;
    end else begin
        case (state)
            STATE_A: begin
                if (x == 1'b1) begin
                    state <= STATE_C;
                end else begin
                    state <= STATE_A;
                end
            end
            STATE_B: begin
                f <= 0;
                state <= STATE_C;
            end
            STATE_C: begin
                if (x == 1'b0) begin
                    state <= STATE_D;
                    seq_counter <= seq_counter + 1;
                end else begin
                    state <= STATE_C;
                    seq_counter <= 0;
                end
            end
            STATE_D: begin
                if (x == 1'b1) begin
                    state <= STATE_E;
                end else begin
                    state <= STATE_C;
                    seq_counter <= 0;
                end
            end
            STATE_E: begin
                if (y_timer == 2'b10) begin
                    if (y) begin
                        state <= STATE_E;
                        g <= 1;
                    end else begin
                        state <= STATE_F;
                        g <= 0;
                    end
                end else begin
                    y_timer <= y_timer + 1;
                end
            end
            STATE_F: begin
                state <= STATE_F;
            end
            default: begin
                state <= STATE_A;
            end
        endcase
        
        if (state == STATE_B) begin
            f <= 1;
        end else if (state == STATE_A) begin
            f <= 0;
            state <= STATE_B;
        end
        
    end
end

endmodule