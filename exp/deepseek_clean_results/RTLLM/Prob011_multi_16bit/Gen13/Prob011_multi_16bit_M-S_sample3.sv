module multi_16bit (
    input clk,
    input rst_n,
    input start,
    input [15:0] ain,
    input [15:0] bin,
    output reg [31:0] yout,
    output done
);

// States
localparam IDLE = 1'b0;
localparam BUSY = 1'b1;

reg state;
reg [3:0] bit_pos;
reg [15:0] areg;
reg [15:0] breg;
reg [31:0] product;

// State machine and calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        bit_pos <= 4'b0;
        areg <= 16'b0;
        breg <= 16'b0;
        product <= 32'b0;
        yout <= 32'b0;
    end
    else begin
        case (state)
            IDLE: begin
                if (start) begin
                    state <= BUSY;
                    areg <= ain;
                    breg <= bin;
                    product <= 32'b0;
                    bit_pos <= 4'b0;
                end
            end
            
            BUSY: begin
                if (areg[bit_pos]) begin
                    product <= product + (breg << bit_pos);
                end
                
                if (bit_pos == 4'b1111) begin
                    yout <= product + (areg[bit_pos] ? (breg << bit_pos) : 0);
                    state <= IDLE;
                end
                else begin
                    bit_pos <= bit_pos + 1;
                end
            end
        endcase
    end
end

assign done = (state == IDLE) && (bit_pos == 4'b1111);

endmodule