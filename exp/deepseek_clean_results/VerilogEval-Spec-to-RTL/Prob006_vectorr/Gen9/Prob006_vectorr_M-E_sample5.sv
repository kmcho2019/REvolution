module TopModule (
    input [7:0] in,
    output reg [7:0] out
);

    reg [2:0] count;
    reg [7:0] shift_reg;
    reg busy;

    // State machine states
    localparam IDLE = 1'b0;
    localparam SHIFTING = 1'b1;
    reg state;

    always @(*) begin
        case (state)
            IDLE: busy = 1'b0;
            SHIFTING: busy = 1'b1;
        endcase
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state <= IDLE;
            count <= 3'd0;
            shift_reg <= 8'd0;
            out <= 8'd0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= SHIFTING;
                        shift_reg <= in;
                        count <= 3'd0;
                    end
                end
                SHIFTING: begin
                    if (count == 3'd7) begin
                        state <= IDLE;
                        out <= shift_reg;
                    end
                    shift_reg <= {shift_reg[6:0], shift_reg[7]};
                    count <= count + 1;
                end
            endcase
        end
    end

    // Clock and reset generation (for simulation)
    reg clk = 0;
    reg reset = 1;
    reg start = 0;

    initial begin
        #10 reset = 0;
        #10 start = 1;
        #10 start = 0;
        #100 $finish;
    end

    always #5 clk = ~clk;

endmodule