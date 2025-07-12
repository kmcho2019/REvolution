module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

reg [1:0] state;
reg [15:0] areg, breg;
reg [31:0] acc;
reg [3:0] count;  // 4-bit counter (0-15)
localparam IDLE = 2'b00;
localparam WORKING = 2'b01;
localparam DONE = 2'b10;

assign done = (state == DONE);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        areg <= 16'b0;
        breg <= 16'b0;
        acc <= 32'b0;
        count <= 4'b0;
        yout <= 32'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (start) begin
                    areg <= ain;
                    breg <= bin;
                    acc <= 32'b0;
                    count <= 4'b0;
                    state <= WORKING;
                end
            end
            
            WORKING: begin
                // Power-efficient conditional accumulation
                if (areg[count]) begin
                    acc <= acc + (breg << count);
                end
                
                if (count == 4'b1111) begin  // count == 15
                    yout <= areg[15] ? acc + (breg << 15) : acc;
                    state <= DONE;
                end
                else begin
                    count <= count + 1;
                end
            end
            
            DONE: begin
                if (!start) begin
                    state <= IDLE;
                end
            end
        endcase
    end
end

endmodule