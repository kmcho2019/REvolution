module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output wire [31:0] yout,
    output wire done
);

    // One-hot state encoding
    localparam IDLE = 3'b001;
    localparam LOAD = 3'b010;
    localparam CALC = 3'b100;
    
    reg [2:0] state;
    reg [15:0] mask;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    
    // Next state logic (combinational)
    wire next_idle = !rst_n || (state == CALC && mask[15]) || (state == LOAD && !start);
    wire next_load = rst_n && ((state == IDLE && start) || (state == CALC && mask[15]));
    wire next_calc = rst_n && (state == LOAD || (state == CALC && !mask[15]));
    
    // State transition (sequential)
    always @(posedge clk) begin
        state <= {next_calc, next_load, next_idle};
    end
    
    // Datapath control
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            mask <= 16'h0001;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
        end else begin
            case (1'b1)
                state[0]: begin // IDLE
                    mask <= 16'h0001;
                    accumulator <= 32'd0;
                end
                state[1]: begin // LOAD
                    areg <= ain;
                    breg <= bin;
                end
                state[2]: begin // CALC
                    if (areg & mask) begin
                        accumulator <= accumulator + ({16'b0, breg} << $clog2(mask));
                    end
                    mask <= {mask[14:0], 1'b0};
                end
            endcase
        end
    end
    
    // Output assignments
    assign yout = (state == CALC && mask[15]) ? accumulator : 32'd0;
    assign done = (state == CALC && mask[15]);
    
endmodule