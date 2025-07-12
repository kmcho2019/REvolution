module TopModule (
    input clk,
    input resetn,
    input x,
    input y,
    output reg f,
    output reg g
);

// State encoding
localparam STATE_A = 2'b00;
localparam STATE_B = 2'b01;
localparam STATE_C = 2'b10;

reg [1:0] state;
reg [1:0] x_history;  // Stores last two x values
reg [1:0] timeout;

// State transitions
always @(posedge clk) begin
    if (!resetn) begin
        state <= STATE_A;
        x_history <= 2'b00;
        timeout <= 2'b00;
        f <= 0;
        g <= 0;
    end else begin
        case (state)
            STATE_A: begin
                state <= STATE_B;
                f <= 1;
                g <= 0;
                x_history <= 2'b00;
            end
            
            STATE_B: begin
                f <= 0;
                x_history <= {x_history[0], x};
                
                // Check for 1-0-1 sequence (current x is last in sequence)
                if (x_history == 2'b10 && x == 1'b1) begin
                    state <= STATE_C;
                    g <= 1;
                    timeout <= 0;
                end
            end
            
            STATE_C: begin
                if (y) begin
                    // Stay in STATE_C with g=1 permanently
                    timeout <= 0;
                end else if (timeout < 2) begin
                    timeout <= timeout + 1;
                end else begin
                    g <= 0;
                end
            end
        endcase
    end
end

endmodule