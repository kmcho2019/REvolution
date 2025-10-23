module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // State definitions
    localparam IDLE = 2'b00;
    localparam RUN  = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [31:0] acc;
    reg [31:0] shifted_bin;

    // Combinational outputs
    assign yout = acc;
    assign done = (state == DONE);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'b0;
            areg <= 16'b0;
            acc <= 32'b0;
            shifted_bin <= 32'b0;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        state <= RUN;
                        areg <= ain;
                        acc <= 32'b0;
                        shifted_bin <= {16'b0, bin};
                        count <= 4'b0;
                    end
                end
                
                RUN: begin
                    // Conditional accumulation
                    if (areg[count]) begin
                        acc <= acc + shifted_bin;
                    end
                    
                    // Shift only when needed for power efficiency
                    if (count < 15) begin
                        shifted_bin <= shifted_bin << 1;
                    end
                    
                    // State transition
                    if (count == 4'b1111) begin
                        state <= DONE;
                    end
                    
                    count <= count + 1;
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