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
    parameter IDLE = 2'b00;
    parameter LOAD = 2'b01;
    parameter CALC = 2'b10;
    parameter DONE = 2'b11;
    
    reg [1:0] state;
    reg [4:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    
    // Combinational shift operation
    wire [31:0] shifted_b = breg << (count-1);
    
    // State machine and datapath
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'b0;
            breg <= 16'b0;
            yout <= 32'b0;
            done <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        state <= LOAD;
                        count <= 5'd0;
                    end
                end
                
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    yout <= 32'b0;
                    state <= CALC;
                    count <= count + 1;
                end
                
                CALC: begin
                    if (count < 17) begin
                        if (areg[count-1]) begin
                            yout <= yout + shifted_b;
                        end
                        count <= count + 1;
                    end else begin
                        state <= DONE;
                    end
                end
                
                DONE: begin
                    done <= 1'b1;
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule