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
    localparam CALC1 = 4'b0100;  // First stage of calculation
    localparam CALC2 = 4'b1000;  // Second stage of calculation

    reg [3:0] state;
    reg [4:0] count;  // 5-bit counter for 16 iterations
    reg [15:0] areg;
    reg [15:0] breg;
    reg [31:0] accumulator;
    reg [16:0] shifted_b;  // Optimized shifter width
    reg [31:0] add_result;
    reg calc_en;

    // Clock gating for shifted_b calculation
    always @(*) begin
        if (state == CALC1 || state == CALC2)
            shifted_b = {1'b0, breg} << count;
        else
            shifted_b = 17'b0;
    end

    // Next state logic (combinational)
    wire [3:0] next_state;
    assign next_state = 
        (!rst_n) ? IDLE :
        (state == IDLE) ? (start ? LOAD : IDLE) :
        (state == LOAD) ? CALC1 :
        (state == CALC1) ? CALC2 :
        (state == CALC2) ? ((count == 15) ? IDLE : CALC1) : IDLE;

    // State transition (sequential)
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            state <= IDLE;
            count <= 5'd0;
            areg <= 16'd0;
            breg <= 16'd0;
            accumulator <= 32'd0;
            add_result <= 32'd0;
            yout <= 32'd0;
            calc_en <= 1'b0;
        end else begin
            state <= next_state;
            
            case (state)
                IDLE: begin
                    count <= 5'd0;
                    accumulator <= 32'd0;
                    yout <= (state == IDLE && count == 15) ? accumulator : yout;
                    calc_en <= 1'b0;
                end
                
                LOAD: begin
                    areg <= ain;
                    breg <= bin;
                    count <= 5'd0;
                    calc_en <= 1'b1;
                end
                
                CALC1: begin
                    if (areg[count]) begin
                        add_result <= accumulator + {15'b0, shifted_b};
                    end else begin
                        add_result <= accumulator;
                    end
                end
                
                CALC2: begin
                    accumulator <= add_result;
                    count <= count + 1;
                end
            endcase
        end
    end

    // Output assignments
    always @(posedge clk) begin
        if (state == CALC2 && count == 15)
            yout <= accumulator;
    end

    assign done = (state == CALC2 && count == 15);

endmodule