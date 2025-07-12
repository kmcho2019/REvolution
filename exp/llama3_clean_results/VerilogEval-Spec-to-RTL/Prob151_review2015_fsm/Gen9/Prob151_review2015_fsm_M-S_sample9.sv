module TopModule(
    input  clk,
    input  reset,
    input  data,
    input  done_counting,
    input  ack,
    output reg shift_ena,
    output reg counting,
    output reg done
);

reg [3:0] pattern_detector;
reg [3:0] shift_register;
reg [1:0] shift_count;
reg counting_done;

always @(posedge clk) begin
    if (reset) begin
        pattern_detector <= 4'b0000;
        shift_register <= 4'b0000;
        shift_count <= 2'b00;
        counting_done <= 1'b0;
        counting <= 1'b0;
        done <= 1'b0;
    end else begin
        pattern_detector[3:1] <= pattern_detector[2:0];
        pattern_detector[0] <= data;
        
        if (pattern_detector == 4'b1101) begin
            shift_ena <= 1'b1;
            shift_count <= shift_count + 1'b1;
            shift_register[3:1] <= shift_register[2:0];
            shift_register[0] <= data;
            
            if (shift_count == 2'b11) begin // Shifted 4 times
                shift_ena <= 1'b0;
                counting <= 1'b1;
            end
        end else if (counting) begin
            if (done_counting &&!counting_done) begin
                counting_done <= 1'b1;
                done <= 1'b1;
            end
            
            if (ack && counting_done) begin
                counting <= 1'b0;
                done <= 1'b0;
                counting_done <= 1'b0;
            end
        end else begin
            shift_ena <= 1'b0;
        end
    end
end

endmodule