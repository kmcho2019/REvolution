module multi_16bit (
    input  clk, 
    input  rst_n, 
    input  start, 
    input  [15:0] ain, 
    input  [15:0] bin, 
    output [31:0] yout, 
    output done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [4:0] i;
reg done_r;
reg [1:0] state;

localparam IDLE = 2'b00;
localparam RUNNING = 2'b01;
localparam DONE = 2'b10;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        i <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        done_r <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= RUNNING;
                    areg <= ain;
                    breg <= bin;
                    yout_r <= 0;
                    i <= 1;
                end
            end
            RUNNING: begin
                if (i < 17) begin
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    i <= i + 1;
                    if (i == 16) begin
                        state <= DONE;
                    end
                end
            end
            DONE: begin
                done_r <= 1;
                if (!start) begin
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