module multi_16bit (
    input wire clk,
    input wire rst_n,
    input wire start,
    input wire [15:0] ain,
    input wire [15:0] bin,
    output reg [31:0] yout,
    output wire done
);

    // One-hot state encoding
    localparam IDLE  = 4'b0001;
    localparam LOAD  = 4'b0010;
    localparam CALC  = 4'b0100;
    localparam DONE  = 4'b1000;

    reg [3:0] state;
    reg [4:0] count;  // Properly sized for 0-16
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    reg [31:0] acc_reg;  // Pipeline register
    
    // Clock-gated shift calculation
    wire [31:0] shifted_b;
    wire shift_en = (state == CALC);
    assign shifted_b = shift_en ? {16'b0, breg} << count : 32'b0;

    // Pipelined addition
    wire [31:0] next_acc = accumulator + shifted_b;

    // Next state logic (optimized)
    always @(*) begin
        case (state)
            IDLE: state = start ? LOAD : IDLE;
            LOAD: state = CALC;
            CALC: state = (count == 5'd15) ? DONE : CALC;
            DONE: state = start ? LOAD : IDLE;
            default: state = IDLE;
        endcase
    end

    // State transition (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
            acc_reg <= 32'd0;
            yout <= 32'd0;
        end else begin
            // Pipeline register update
            acc_reg <= next_acc;
            
            case (state)
                IDLE: begin
                    count <= 5'd0;
                    accumulator <= 32'd0;
                end
                
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    count <= 5'd0;
                end
                
                CALC: begin
                    if (areg[count]) begin
                        accumulator <= acc_reg;  // Use pipelined result
                    end
                    count <= count + 1;
                end
                
                DONE: begin
                    yout <= accumulator;  // Registered output
                end
            endcase
        end
    end

    // Output assignments
    assign done = (state == DONE);

endmodule