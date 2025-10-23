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
    localparam IDLE = 1'b0;
    localparam CALC = 1'b1;
    
    reg state, next_state;
    reg [3:0] count;
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] acc;
    
    // Dynamic shift calculation
    wire [31:0] shifted_b = breg << count;
    wire acc_enable = (state == CALC) && areg[count];
    
    // State machine
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 4'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            acc <= 32'd0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    if (start) begin
                        areg <= ain;
                        breg <= bin;
                        acc <= 32'd0;
                        count <= 4'd0;
                    end
                end
                CALC: begin
                    if (acc_enable) begin
                        acc <= acc + shifted_b;
                    end
                    count <= count + 1;
                end
            endcase
        end
    end
    
    // Next state logic (combinational)
    always @(*) begin
        case (state)
            IDLE: next_state = start ? CALC : IDLE;
            CALC: next_state = (count == 4'd15) ? IDLE : CALC;
            default: next_state = IDLE;
        endcase
    end
    
    // Output assignments
    assign yout = (state == CALC && count == 4'd15) ? (acc + (areg[15] ? shifted_b : 32'd0)) : 
                 (state == IDLE && count == 4'd0) ? acc : 32'd0;
    assign done = (state == CALC && count == 4'd15);
    
endmodule