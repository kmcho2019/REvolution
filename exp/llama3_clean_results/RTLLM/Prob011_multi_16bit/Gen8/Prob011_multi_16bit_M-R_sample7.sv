module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output reg [31:0] yout, 
    output reg done
);

reg [15:0] areg;
reg [15:0] breg;
reg [4:0] i;
reg [31:0] yout_r;
reg done_r;

// Control logic
reg [2:0] state;
localparam IDLE = 3'b001;
localparam START = 3'b010;
localparam MULTIPLY = 3'b011;
localparam DONE = 3'b100;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        state <= IDLE;
        i <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= START;
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 0;
                    i <= 1;
                end
            end
            START: begin
                state <= MULTIPLY;
            end
            MULTIPLY: begin
                if (i < 17) begin
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    i <= i + 1;
                    if (i == 16) begin
                        done_r <= 1;
                        state <= DONE;
                    end
                end
            end
            DONE: begin
                if (~start) begin
                    state <= IDLE;
                    done_r <= 0;
                end
            end
        endcase
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule