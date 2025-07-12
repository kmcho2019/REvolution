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
    localparam IDLE  = 4'b0001;
    localparam LOAD  = 4'b0010;
    localparam CALC  = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state;
    reg [4:0] count;  // 5 bits for 0-16
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    reg [31:0] acc_reg;  // Pipeline register
    
    // Shifted versions of multiplier (pre-computed)
    wire [31:0] shifted_b = {16'b0, breg} << count;
    wire calc_active = state[2];  // CALC state bit

    // Next state logic (combinational)
    wire [3:0] next_state;
    assign next_state = 
        (!rst_n) ? IDLE :
        (state == IDLE) ? (start ? LOAD : IDLE) :
        (state == LOAD) ? CALC :
        (state == CALC) ? ((count == 5'd15) ? DONE : CALC) :
        (state == DONE) ? (start ? LOAD : IDLE) : IDLE;

    // State transition (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
            acc_reg <= 32'd0;
        end else begin
            state <= next_state;
            
            case (1'b1)  // synthesis parallel_case
                state[0]: begin // IDLE
                    count <= 5'd0;
                    accumulator <= 32'd0;
                    acc_reg <= 32'd0;
                end
                
                state[1]: begin // LOAD
                    areg <= ain;
                    breg <= bin;
                    count <= 5'd0;
                end
                
                state[2]: begin // CALC
                    acc_reg <= accumulator;  // Pipeline stage
                    if (areg[count]) begin
                        accumulator <= acc_reg + shifted_b;
                    end
                    count <= count + 1;
                end
                
                state[3]: begin // DONE
                    // Hold values until next start
                end
            endcase
        end
    end

    // Output assignments with enable
    assign yout = (state == DONE) ? accumulator : 32'd0;
    assign done = state[3];  // DONE state bit

endmodule