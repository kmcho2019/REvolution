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
    localparam LOAD = 2'b01;
    localparam CALC = 2'b10;
    localparam DONE = 2'b11;

    reg [1:0] state;
    reg [4:0] count;
    reg [15:0] areg;
    reg [31:0] yout_r;

    // Barrel shifter for multiplier
    wire [31:0] shifted_bin = bin << count;

    // State transitions
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'b0;
            yout_r <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= LOAD;
                        areg <= ain;
                    end
                end
                LOAD: begin
                    yout_r <= 32'b0;
                    count <= 5'd0;
                    state <= CALC;
                end
                CALC: begin
                    if (areg[count]) begin
                        yout_r <= yout_r + shifted_bin;
                    end
                    
                    if (count == 15) begin
                        state <= DONE;
                    end else begin
                        count <= count + 1;
                    end
                end
                DONE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Output assignments
    assign yout = yout_r;
    assign done = (state == DONE);

endmodule