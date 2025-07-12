module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam CALC = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state, next_state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg [31:0] shifted_bin;
    reg done_reg;

    // State transition
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
        end else begin
            state <= next_state;
        end
    end

    // Next state logic
    always @(*) begin
        case (state)
            IDLE: next_state = start ? CALC : IDLE;
            CALC: next_state = (count == 15) ? DONE : CALC;
            DONE: next_state = IDLE;
            default: next_state = IDLE;
        endcase
    end

    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'b0;
            acc <= 32'b0;
            shifted_bin <= 32'b0;
            count <= 4'b0;
            done_reg <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    areg <= 16'b0;
                    acc <= 32'b0;
                    shifted_bin <= 32'b0;
                    count <= 4'b0;
                    done_reg <= 1'b0;
                    if (start) begin
                        areg <= ain;
                        shifted_bin <= {16'b0, bin};
                    end
                end
                CALC: begin
                    if (areg[count]) begin
                        acc <= acc + (shifted_bin << count);
                    end
                    count <= count + 1;
                    done_reg <= (count == 14); // Early done flag
                end
                DONE: begin
                    done_reg <= 1'b1;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = acc;
    assign done = done_reg;

endmodule