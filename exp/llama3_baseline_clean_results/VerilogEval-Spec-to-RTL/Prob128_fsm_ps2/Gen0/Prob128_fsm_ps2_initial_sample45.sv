module TopModule (
    input        clk,
    input        reset,
    input  [7:0] in,
    output       done
);

reg [1:0] state; // IDLE, BYTE1, BYTE2, BYTE3
reg        done_reg;

// State encoding
localparam IDLE  = 2'b00;
localparam BYTE1 = 2'b01;
localparam BYTE2 = 2'b10;
localparam BYTE3 = 2'b11;

always @(posedge clk) begin
    if (reset) begin
        state <= IDLE;
        done_reg <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (in[3] == 1'b1) begin
                    state <= BYTE1;
                end else begin
                    state <= IDLE;
                end
            end
            BYTE1: begin
                state <= BYTE2;
            end
            BYTE2: begin
                state <= BYTE3;
            end
            BYTE3: begin
                state <= IDLE;
                done_reg <= 1'b1;
            end
            default: state <= IDLE;
        endcase
    end
end

always @(posedge clk) begin
    if (reset) begin
        done <= 1'b0;
    end else if (done_reg) begin
        done <= 1'b1;
        done_reg <= 1'b0;
    end else begin
        done <= 1'b0;
    end
end

endmodule