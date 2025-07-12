module TopModule (
    output one
);
    reg counter = 0;
    always #1 counter = ~counter;  // Toggle every time unit
    
    assign one = counter | (~counter);  // Always evaluates to 1
endmodule