module TopModule (
  input clk,
  input resetn,
  input x,
  input y,
  output reg f,
  output reg g
);

// State Definitions
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;

// Define state register
reg [1:0] state, next_state;
reg [2:0] x_history;
reg [1:0] y_counter;

// Define state transition and output logic
always @(posedge clk or negedge resetn) begin
    if (~resetn) begin
        state <= A;
        f <= 0;
        g <= 0;
    end
    else begin
        state <= next_state;
        case (state)
            A: begin
                f <= 1;
                next_state <= B;
            end
            B: begin
                if (x_history == 3'b101)
                    next_state <= C;
                else
                    next_state <= B;                
                x_history <= {x_history[1:0], x};
            end
            C: begin
                if (g) begin
                    if (y) begin
                        g <= 1;
                    end
                    else begin
                        if (y_counter < 2)
                            y_counter <= y_counter + 1;
                        else
                            g <= 0;
                    end
                end
                else begin
                    if (y) begin
                        g <= 1;
                    end
                end
                next_state <= C;
            end
        endcase
    end
end

endmodule