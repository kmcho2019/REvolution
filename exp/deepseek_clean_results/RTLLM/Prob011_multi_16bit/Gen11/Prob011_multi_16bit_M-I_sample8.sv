module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output reg done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    reg [31:0] shifted_b;
    reg add_en;

    // State machine and control logic
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
            done <= 1'b0;
            add_en <= 1'b0;
        end
        else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        state <= LOAD;
                        accumulator <= 32'd0;
                    end
                end
                
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    count <= 4'd0;
                    state <= CALC;
                end
                
                CALC: begin
                    if (count < 16) begin
                        shifted_b <= breg << count;
                        add_en <= areg[count];
                        if (add_en) begin
                            accumulator <= accumulator + shifted_b;
                        end
                        count <= count + 1;
                    end
                    else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    yout <= accumulator;
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule