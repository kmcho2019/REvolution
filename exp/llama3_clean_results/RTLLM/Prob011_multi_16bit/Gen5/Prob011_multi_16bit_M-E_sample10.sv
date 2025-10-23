module multi_16bit(
    input clk, 
    input rst_n, 
    input start, 
    input [15:0] ain, 
    input [15:0] bin, 
    output [31:0] yout, 
    output done
);

reg [15:0] areg;
reg [15:0] breg;
reg [31:0] yout_r;
reg [4:0] i;
reg done_r;
reg [2:0] state;

localparam IDLE = 3'b001;
localparam LOAD = 3'b010;
localparam SHIFT = 3'b011;
localparam ACCUM = 3'b100;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
        i <= 0;
        done_r <= 0;
    end else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= LOAD;
                end
            end
            LOAD: begin
                areg <= ain;
                breg <= bin;
                yout_r <= 0;
                i <= 1;
                state <= SHIFT;
            end
            SHIFT: begin
                if (i < 17) begin
                    if (areg[i-1]) begin
                        yout_r <= yout_r + (breg << (i-1));
                    end
                    i <= i + 1;
                end else begin
                    state <= ACCUM;
                end
            end
            ACCUM: begin
                done_r <= 1;
                state <= IDLE;
            end
        endcase
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule